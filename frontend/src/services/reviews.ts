export interface Review {
  id: string;
  locationId: number;
  author: string;
  rating: number;
  title: string;
  comment: string;
  createdAt: string;
}

export interface NewReview {
  locationId: number;
  author: string;
  rating: number;
  title: string;
  comment: string;
}

const STORAGE_KEY = 'diskover-reviews';

const mockReviews: Review[] = [
  {
    id: 'mock-1',
    locationId: 1,
    author: 'Mika',
    rating: 5,
    title: 'Easy to find',
    comment: 'The map directions were accurate and the place was easy to locate.',
    createdAt: '2026-02-14T09:30:00.000Z',
  },
  {
    id: 'mock-2',
    locationId: 1,
    author: 'Paolo',
    rating: 4,
    title: 'Helpful location details',
    comment: 'The photos and nearby locations made planning my visit easier.',
    createdAt: '2026-02-18T14:15:00.000Z',
  },
  {
    id: 'mock-3',
    locationId: 2,
    author: 'Sam',
    rating: 5,
    title: 'Good reference',
    comment: 'The listing had the information I needed before heading there.',
    createdAt: '2026-02-20T08:45:00.000Z',
  },
];

const readStoredReviews = (): Review[] => {
  let storedReviews: string | null;

  try {
    storedReviews = localStorage.getItem(STORAGE_KEY);
  } catch (error) {
    console.warn('Unable to access saved reviews:', error);
    return [];
  }

  if (!storedReviews) {
    return [];
  }

  try {
    const parsedReviews: unknown = JSON.parse(storedReviews);
    return Array.isArray(parsedReviews) ? (parsedReviews as Review[]) : [];
  } catch (error) {
    console.warn('Unable to read saved reviews:', error);
    return [];
  }
};

const writeStoredReviews = (reviews: Review[]) => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(reviews));
};

export const getReviews = (locationId: number): Review[] => {
  const savedReviews = readStoredReviews().filter(
    (review) => review.locationId === locationId
  );
  const seededReviews = mockReviews.filter(
    (review) =>
      review.locationId === locationId &&
      !savedReviews.some((savedReview) => savedReview.id === review.id)
  );

  return [...savedReviews, ...seededReviews].sort(
    (firstReview, secondReview) =>
      new Date(secondReview.createdAt).getTime() -
      new Date(firstReview.createdAt).getTime()
  );
};

export const createReview = (review: NewReview): Review => {
  const newReview: Review = {
    ...review,
    id: `local-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
    createdAt: new Date().toISOString(),
  };
  const savedReviews = readStoredReviews();

  writeStoredReviews([...savedReviews, newReview]);
  return newReview;
};
